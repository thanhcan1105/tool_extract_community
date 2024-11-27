//Import
function setupDragHandlers() {
	Blockbench.addDragHandler(
		'texture',
		{ extensions: ['png', 'tga'], propagate: true, readtype: 'image', condition: () => !Dialog.open },
		function (files, event) {
			loadImages(files, event)
		}
	)
	Blockbench.addDragHandler(
		'model',
		{ extensions: Codec.getAllExtensions },
		function (files) {
			files.forEach(file => {
				loadModelFile(file);
			})
		}
	)
	Blockbench.addDragHandler(
		'style',
		{ extensions: ['bbtheme'] },
		function (files) {
			CustomTheme.import(files[0]);
		}
	)
	Blockbench.addDragHandler(
		'settings',
		{ extensions: ['bbsettings'] },
		function (files) {
			Settings.import(files[0]);
		}
	)
	Blockbench.addDragHandler(
		'plugin',
		{ extensions: ['bbplugin', 'js'] },
		function (files) {
			files.forEach(file => {
				new Plugin().loadFromFile(file, true);
			})
		}
	)
}

window.screenshotTexture = function screenshotTexture() {
	Preview.selected.setDefaultAnglePreset({
		name: 'menu.preview.angle.initial',
		id: 'initial',
		projection: 'perspective',
		zoom: 25.5,
		position: [-98, 55, -105],
		target: [0, 16, 0],
		default: true
	});

	Preview.selected.screenshot({ width: 640, height: 480 });
}

window.allowPickFile = async function allowPickFile() {
	let answer = await new Promise((resolve) => {
		new Dialog({
			id: 'text_input',
			title: 'Warning Load Data',
			form: {
				content: { type: 'info', text: 'If you pick new data, your current data will not be saved!' },
			},
			onConfirm({ text }) {
				resolve('true');
			},
		}).show();
	});

	AllowPickFile.postMessage(answer);
}

window.warningBack = async function warningBack() {
	let answer = await new Promise((resolve) => {
		new Dialog({
			id: 'text_input',
			title: 'Confirm Exit',
			form: {
				content: { type: 'info', text: 'If you leave the page, your data will not be saved!' },
			},
			onConfirm({ text }) {
				resolve('true');
			},
		}).show();
	});

	WarningBack.postMessage(answer);
	return true;
}

function loadModelApp(file, model) {
	let existing_tab = isApp && ModelProject.all.find(project => (
		project.save_path == file.path || project.export_path == file.path
	))

	let extension = pathToExtension(file.path);

	function loadIfCompatible(codec, type, content) {
		if (codec.load_filter && codec.load_filter.type == type) {
			if (codec.load_filter.extensions.includes(extension) && Condition(codec.load_filter.condition, content)) {
				if (existing_tab && !codec.multiple_per_file) {
					existing_tab.select();
				} else {
					codec.load(model, file);
				}
				return true;
			}
		}
	}

	// Image
	for (let id in Codecs) {
		let success = loadIfCompatible(Codecs[id], 'image', model);
		if (success) return;
	}
	// Text
	for (let id in Codecs) {
		let success = loadIfCompatible(Codecs[id], 'text', file.content);
		if (success) return;
	}
	// JSON
	for (let id in Codecs) {
		let success = loadIfCompatible(Codecs[id], 'json', model);
		if (success) return;
	}
}

function loadTextureApp(fileName, fileContent) {
	var new_textures = []
	Undo.initEdit({ textures: new_textures })

	let file = { name: fileName, path: fileName, no_file: true, content: fileContent };
	var t = new Texture({ name: fileName }).fromFile(file).add(false).fillParticle()
	new_textures.push(t)

	Undo.finishEdit('Add texture')

	if (Texture.all.length > 1) {
		Texture.all.last().select()
	}
}

const skin_presets = {};

const codec = new Codec('skin_model', {
	name: 'Skin Model',
	remember: false,
	compile(options) {
		if (options === undefined) options = 0;
		var entitymodel = {
			name: Project.geometry_name.split('.')[0]
		}
		entitymodel.texturewidth = Project.texture_width;
		entitymodel.textureheight = Project.texture_height;
		var bones = []

		var groups = getAllGroups();

		groups.forEach(function (g) {
			if (g.type !== 'group') return;
			//Bone
			var bone = {}
			bone.name = g.name
			if (g.parent.type === 'group') {
				bone.parent = g.parent.name
			}
			bone.pivot = g.origin.slice()
			bone.pivot[0] *= -1
			if (!g.rotation.allEqual(0)) {
				bone.rotation = [
					-g.rotation[0],
					-g.rotation[1],
					g.rotation[2]
				]
			}
			if (g.reset) bone.reset = true;
			if (g.mirror_uv) bone.mirror = true;

			//Elements
			var cubes = []
			for (var obj of g.children) {
				if (obj.export) {
					if (obj instanceof Cube) {

						let template = Codecs.bedrock.compileCube(obj, g);
						cubes.push(template)

					}
				}
			}
			if (cubes.length) {
				bone.cubes = cubes
			}
			bones.push(bone)
		})

		if (bones.length) {
			entitymodel.bones = bones
		}
		this.dispatchEvent('compile', { model: entitymodel, options });
		return entitymodel
	},
	parse(data, resolution, texture_path, pose = true, layer_template) {
		this.dispatchEvent('parse', { model: data });
		Project.texture_width = data.texturewidth || 64;
		Project.texture_height = data.textureheight || 64;

		Interface.Panels.skin_pose.inside_vue.pose = Project.skin_pose = pose ? 'natural' : 'none';

		var bones = {}
		var template_cubes = {};

		if (data.bones) {
			var included_bones = []
			data.bones.forEach(function (b) {
				included_bones.push(b.name)
			})
			data.bones.forEach(function (b, bi) {
				var group = new Group({
					name: b.name,
					origin: b.pivot,
					rotation: (pose && b.pose) ? b.pose : b.rotation
				}).init()
				group.isOpen = true;
				bones[b.name] = group
				if (b.pivot) {
					group.origin[0] *= -1
				}
				group.rotation[0] *= -1;
				group.rotation[1] *= -1;

				group.mirror_uv = b.mirror === true
				group.reset = b.reset === true
				group.skin_original_origin = group.origin.slice();

				if (b.cubes) {
					b.cubes.forEach(function (cube) {

						let base_cube = Codecs.bedrock.parseCube(cube, group);
						template_cubes[Cube.all.indexOf(base_cube)] = cube;

					})
				}
				if (b.children) {
					b.children.forEach(function (cg) {
						cg.addTo(group)
					})
				}
				var parent_group = 'root';
				if (b.parent) {
					if (bones[b.parent]) {
						parent_group = bones[b.parent]
					} else {
						data.bones.forEach(function (ib) {
							if (ib.name === b.parent) {
								ib.children && ib.children.length ? ib.children.push(group) : ib.children = [group]
							}
						})
					}
				}
				group.addTo(parent_group)
			})
		}
		if (texture_path) {
			var texture = new Texture().fromPath(texture_path).add(false);
		} else if (resolution) {
			var texture = generateTemplate(
				Project.texture_width * resolution,
				Project.texture_height * resolution,
				template_cubes,
				data.name,
				data.eyes,
				layer_template
			)
		}
		for (var index in template_cubes) {
			if (template_cubes[index].visibility === false) {
				Cube.all[index].visibility = false;
			}
		}
		if (texture) {
			texture.load_callback = function () {
				Modes.options.paint.select();
			}
		}
		if (data.camera_angle) {
			main_preview.loadAnglePreset(DefaultCameraPresets.find(p => p.id == data.camera_angle))
		}
		loadTextureDraggable()
		Canvas.updateAllBones()
		Canvas.updateVisibility()
		setProjectTitle()
		updateSelection()
	},
})

const format = new ModelFormat('skin', {
	icon: 'icon-player',
	category: 'minecraft',
	target: ['Minecraft: Java Edition', 'Minecraft: Bedrock Edition'],
	format_page: {
		content: [
			{ type: 'h3', text: tl('mode.start.format.informations') },
			{
				text: `* ${tl('format.skin.info.skin')}
					* ${tl('format.skin.info.model')}`.replace(/\t+/g, '')
			},
			{ type: 'h3', text: tl('mode.start.format.resources') },
			{ text: `* [Skin Design Tutorial](https://youtu.be/xC81Q3HGraE)` }
		]
	},
	can_convert_to: false,
	model_identifier: false,
	bone_rig: true,
	box_uv: true,
	centered_grid: true,
	single_texture: true,
	integer_size: true,
	rotate_cubes: false,
	edit_mode: false,
	pose_mode: true,
	codec
})

window.loadTextureAppSkin = function loadTextureAppSkin(content) {
	console.log('contentaaa: ' + content);
	var result = { "model": "steve", "variant": "java_edition", "resolution": 128, "texture": "data:image/png;base64," + content, "pose": true, "layer_template": true };

	if (newProject(format)) {
		let preset = skin_presets.steve;
		let model = JSON.parse(preset.model || preset.model_bedrock);
		console.log(model)
		codec.parse(model, result.resolution / 16, result.texture, result.pose, result.layer_template);
		Project.skin_model = result.model + '.' + 'bedrock';
	}

	let edited = [];
	Cube.all.forEach(cube => {
		if (cube.name.toLowerCase().includes('layer')) {
			edited.push(cube);
		}
	})
	if (!edited.length) return;
	Undo.initEdit({ elements: edited });
	let value = !edited[0].visibility;
	edited.forEach(cube => {
		cube.visibility = value;
	})
	Undo.finishEdit('Toggle skin layer');
	Canvas.updateVisibility()
}

format.presets = skin_presets;


skin_presets.steve = {
	display_name: 'Steve',
	pose: true,
	model: `{
		"name": "steve",
		"texturewidth": 64,
		"textureheight": 64,
		"eyes": [
			[9, 11],
			[13, 11]
		],
		"bones": [
			{
				"name": "Head",
				"color": 1,
				"pivot": [0, 24, 0],
				"pose": [-6, 5, 0],
				"cubes": [
					{"name": "Head", "origin": [-4, 24, -4], "size": [8, 8, 8], "uv": [0, 0]},
					{"name": "Hat Layer", "visibility": false, "origin": [-4, 24, -4], "size": [8, 8, 8], "uv": [32, 0], "inflate": 0.5, "layer": true}
				]
			},
			{
				"name": "Body",
				"color": 3,
				"pivot": [0, 24, 0],
				"cubes": [
					{"name": "Body", "origin": [-4, 12, -2], "size": [8, 12, 4], "uv": [16, 16]},
					{"name": "Body Layer", "visibility": false, "origin": [-4, 12, -2], "size": [8, 12, 4], "uv": [16, 32], "inflate": 0.25, "layer": true}
				]
			},
			{
				"name": "Right Arm",
				"color": 5,
				"pivot": [-5, 22, 0],
				"pose": [-10, 0, 0],
				"cubes": [
					{"name": "Right Arm", "origin": [-8, 12, -2], "size": [4, 12, 4], "uv": [40, 16]},
					{"name": "Right Arm Layer", "visibility": false, "origin": [-8, 12, -2], "size": [4, 12, 4], "uv": [40, 32], "inflate": 0.25, "layer": true}
				]
			},
			{
				"name": "Left Arm",
				"color": 0,
				"pivot": [5, 22, 0],
				"pose": [12, 0, 0],
				"cubes": [
					{"name": "Left Arm", "origin": [4, 12, -2], "size": [4, 12, 4], "uv": [32, 48]},
					{"name": "Left Arm Layer", "visibility": false, "origin": [4, 12, -2], "size": [4, 12, 4], "uv": [48, 48], "inflate": 0.25, "layer": true}
				]
			},
			{
				"name": "Right Leg",
				"color": 6,
				"pivot": [-1.9, 12, 0],
				"pose": [11, 0, 2],
				"cubes": [
					{"name": "Right Leg", "origin": [-3.9, 0, -2], "size": [4, 12, 4], "uv": [0, 16]},
					{"name": "Right Leg Layer", "visibility": false, "origin": [-3.9, 0, -2], "size": [4, 12, 4], "uv": [0, 32], "inflate": 0.25, "layer": true}
				]
			},
			{
				"name": "Left Leg",
				"color": 7,
				"pivot": [1.9, 12, 0],
				"pose": [-10, 0, -2],
				"cubes": [
					{"name": "Left Leg", "origin": [-0.1, 0, -2], "size": [4, 12, 4], "uv": [16, 48]},
					{"name": "Left Leg Layer", "visibility": false, "origin": [-0.1, 0, -2], "size": [4, 12, 4], "uv": [0, 48], "inflate": 0.25, "layer": true}
				]
			}
		]
	}`
};


window.loadModelFromApp = async function loadModelFromApp(modelData) {
	for (let i = 0; i < modelData['data'].length; i++) {
		console.log(modelData['data'][i]);

		if (modelData['data'][i]['type'].includes("model")) {
			loadModelApp({ path: modelData['data'][i]['file_name'], no_file: true }, JSON.parse(JSON.stringify(modelData['data'][i]['data'])));
		} else if (modelData['data'][i]['type'].includes("texture")) {
			loadTextureApp(modelData['data'][i]['file_name'], "data:image/png;base64," + modelData['data'][i]['data']);
		}
	}

	Modes.options.animate.delete();
	Modes.options.edit.delete();

	if (modelData['type'].includes('texture')) {
		await Modes.options.paint.select();
		Canvas.updatePaintingGrid();
		UVEditor.vue.pixel_grid = value;
	} else if (modelData['type'].includes('model')) {
		await Modes.options.edit.select();
	}
};

window.saveDataToApp = function saveDataToApp() {
	ImageReturn.postMessage(Texture.getDefault().source);
	return Texture.getDefault().source;
};

function loadModelFile(file) {
	// ModelProject.selected
	let existing_tab = isApp && ModelProject.all.find(project => (
		project.save_path == file.path || project.export_path == file.path
	))

	let extension = pathToExtension(file.path);

	function loadIfCompatible(codec, type, content) {
		if (codec.load_filter && codec.load_filter.type == type) {
			if (codec.load_filter.extensions.includes(extension) && Condition(codec.load_filter.condition, content)) {
				if (existing_tab && !codec.multiple_per_file) {
					existing_tab.select();
				} else {
					codec.load(content, file);
				}
				return true;
			}
		}
	}

	// Text
	for (let id in Codecs) {
		let success = loadIfCompatible(Codecs[id], 'image', file.content);
		if (success) return;
	}
	// Text
	for (let id in Codecs) {
		let success = loadIfCompatible(Codecs[id], 'text', file.content);
		if (success) return;
	}
	// JSON
	let model = autoParseJSON(file.content);
	for (let id in Codecs) {
		let success = loadIfCompatible(Codecs[id], 'json', model);
		if (success) return;
	}
}

async function loadImages(files, event) {
	let options = {};
	let texture_li = event && $(event.target).parents('li.texture');
	let replace_texture;

	let img = new Image();
	await new Promise((resolve, reject) => {
		img.src = isApp ? files[0].path : files[0].content;
		img.onload = resolve;
		img.onerror = reject;
	})

	if (Project && texture_li && texture_li.length) {
		replace_texture = Texture.all.findInArray('uuid', texture_li.attr('texid'))
		if (replace_texture) {
			options.replace_texture = 'menu.texture.change';
		}
	}
	if (Project) {
		if (Condition(Panels.textures.condition)) {
			options.texture = 'action.import_texture';
		}
		options.background = 'menu.view.background';
	}
	options.edit = 'message.load_images.edit_image';
	if (img.naturalHeight == img.naturalWidth && [64, 128].includes(img.naturalWidth)) {
		options.minecraft_skin = 'format.skin';
	}
	if (Project && (!Project.box_uv || Format.optional_box_uv)) {
		options.extrude_with_cubes = 'dialog.extrude.title';
	}

	function doLoadImages(method) {
		if (method == 'texture') {
			files.forEach(function (f) {
				new Texture().fromFile(f).add().fillParticle()
			})

		} else if (method == 'replace_texture') {
			replace_texture.fromFile(files[0])
			updateSelection();

		} else if (method == 'background') {
			let preview = Preview.selected;
			let image = isApp ? files[0].path : files[0].content;
			if (isApp && preview.background.image && preview.background.image.replace(/\?\w+$/, '') == image) {
				image = image + '?' + Math.floor(Math.random() * 1000);
			}
			preview.background.image = image;
			preview.loadBackground();
			Settings.saveLocalStorages();
			preview.startMovingBackground();

		} else if (method == 'edit') {
			Codecs.image.load(files, files[0].path, [img.naturalWidth, img.naturalHeight]);

		} else if (method == 'minecraft_skin') {
			Formats.skin.setup_dialog.show();
			Formats.skin.setup_dialog.setFormValues({
				texture: isApp ? files[0].path : files[0].content
			})

		} else if (method == 'extrude_with_cubes') {
			Extruder.dialog.show();
			Extruder.drawImage(files[0]);
		}
	}

	let all_methods = Object.keys(options);
	if (all_methods.length == 1) {
		doLoadImages(all_methods[0]);

	} else if (all_methods.length) {
		let title = tl('message.load_images.title');
		let message = `${files[0].name}`;
		if (files.length > 1) message += ` (${files.length})`;
		Blockbench.showMessageBox({
			id: 'load_images',
			commands: options,
			title, message,
			icon: img,
			buttons: ['dialog.cancel'],
		}, result => {
			doLoadImages(result);
		})
	}
}

//Extruder
const Extruder = {
	dialog: new Dialog({
		id: 'image_extruder',
		title: 'dialog.extrude.title',
		buttons: ['dialog.confirm', 'dialog.cancel'],
		part_order: ['form', 'lines'],
		form: {
			mode: {
				label: 'dialog.extrude.mode',
				type: 'select',
				options: {
					areas: 'dialog.extrude.mode.areas',
					lines: 'dialog.extrude.mode.lines',
					columns: 'dialog.extrude.mode.columns',
					pixels: 'dialog.extrude.mode.pixels'
				}
			},
			orientation: {
				label: 'dialog.extrude.orientation',
				type: 'select',
				options: {
					upright: 'dialog.extrude.orientation.upright',
					flat: 'dialog.extrude.orientation.flat',
				}
			},
			scan_tolerance: {
				label: 'dialog.extrude.opacity',
				type: 'range',
				min: 1, max: 255, value: 255, step: 1,
				editable_range_label: true
			}
		},
		lines: [
			`<canvas height="256" width="256" id="extrusion_canvas" class="checkerboard"></canvas>`
		],
		onConfirm(formResult) {
			Extruder.startConversion(formResult);
		}
	}),
	drawImage(file) {
		Extruder.canvas = $('#extrusion_canvas').get(0)
		var ctx = Extruder.canvas.getContext('2d')

		Extruder.ext_img = new Image()
		Extruder.ext_img.src = isApp ? file.path.replace(/#/g, '%23') : file.content
		Extruder.image_file = file
		Extruder.ext_img.style.imageRendering = 'pixelated'
		Extruder.canvas.style.imageRendering = 'pixelated'

		Extruder.ext_img.onload = function () {
			let ratio = Extruder.ext_img.naturalWidth / Extruder.ext_img.naturalHeight;
			Extruder.canvas.width = 256;
			Extruder.canvas.height = 256 / ratio;
			ctx.clearRect(0, 0, Extruder.canvas.width, Extruder.canvas.height);
			ctx.imageSmoothingEnabled = false;
			ctx.drawImage(Extruder.ext_img, 0, 0, Extruder.canvas.width, Extruder.canvas.height);
			Extruder.width = Extruder.ext_img.naturalWidth;
			Extruder.height = Extruder.ext_img.naturalHeight;

			if (Extruder.width > 128) return;

			var p = 0
			ctx.beginPath();

			for (var x = 0; x < Extruder.canvas.width; x += 256 / Extruder.width) {
				ctx.moveTo(0.5 + x + p, p);
				ctx.lineTo(0.5 + x + p, 256 + p);
			}
			for (var x = 0; x < Extruder.canvas.height; x += 256 / Extruder.width) {
				ctx.moveTo(p, 0.5 + x + p);
				ctx.lineTo(256 + p, 0.5 + x + p);
			}

			ctx.strokeStyle = CustomTheme.data.colors.grid;
			ctx.stroke();
		}
	},
	startConversion(formResult) {
		var scan_mode = formResult.mode;
		var pixel_opacity_tolerance = Math.round(formResult.scan_tolerance);

		//Undo
		Undo.initEdit({ elements: selected, outliner: true, textures: [] })
		var texture = new Texture().fromFile(Extruder.image_file).add(false).fillParticle()

		//var ext_x, ext_y;
		var ctx = Painter.getCanvas(texture).getContext('2d')

		var c = document.createElement('canvas')
		var ctx = c.getContext('2d');
		c.width = Extruder.ext_img.naturalWidth;
		c.height = Extruder.ext_img.naturalHeight;
		ctx.drawImage(Extruder.ext_img, 0, 0)
		var image_data = ctx.getImageData(0, 0, c.width, c.height).data

		var finished_pixels = {}
		var cube_nr = 0;
		var cube_name = texture.name.split('.')[0]
		selected.empty()

		//Scale Index
		var scale_i = 1;
		scale_i = 16 / Extruder.width;
		let uv_scale_x = Project.texture_width / Extruder.width;
		let uv_scale_y = Project.texture_height / Extruder.height;

		function isOpaquePixel(px_x, px_y) {
			var opacity = image_data[(px_x + ctx.canvas.width * px_y) * 4 + 3]
			return Math.isBetween(px_x, 0, Extruder.width - 1)
				&& Math.isBetween(px_y, 0, Extruder.height - 1)
				&& opacity >= pixel_opacity_tolerance;
		}
		function finishPixel(x, y) {
			if (finished_pixels[x] === undefined) {
				finished_pixels[x] = {}
			}
			finished_pixels[x][y] = true
		}
		function isPixelFinished(x, y) {
			return (finished_pixels[x] !== undefined && finished_pixels[x][y] === true)
		}

		//Scanning
		let ext_y = 0;
		while (ext_y < Extruder.height) {

			let ext_x = 0;
			while (ext_x < Extruder.width) {
				if (isPixelFinished(ext_x, ext_y) === false && isOpaquePixel(ext_x, ext_y) === true) {

					//Search From New Pixel
					var loop = true;
					var rect = { x: ext_x, y: ext_y, x2: ext_x, y2: ext_y }
					var safety_limit = 5000

					//Expanding Loop
					while (loop === true && safety_limit) {
						var y_check, x_check, canExpandX, canExpandY;
						//Expand X
						if (scan_mode === 'areas' || scan_mode === 'lines') {
							y_check = rect.y
							x_check = rect.x2 + 1
							canExpandX = true
							while (y_check <= rect.y2) {
								//Check If Row is Free
								if (isOpaquePixel(x_check, y_check) === false || isPixelFinished(x_check, y_check) === true) {
									canExpandX = false;
								}
								y_check += 1
							}
							if (canExpandX === true) {
								rect.x2 += 1
							}
						} else {
							canExpandX = false;
						}
						//Expand Y
						if (scan_mode === 'areas' || scan_mode === 'columns') {
							x_check = rect.x
							y_check = rect.y2 + 1
							canExpandY = true
							while (x_check <= rect.x2) {
								//Check If Row is Free
								if (isOpaquePixel(x_check, y_check) === false || isPixelFinished(x_check, y_check) === true) {
									canExpandY = false
								}
								x_check += 1
							}
							if (canExpandY === true) {
								rect.y2 += 1
							}
						} else {
							canExpandY = false;
						}
						//Conclusion
						if (canExpandX === false && canExpandY === false) {
							loop = false;
						}
						safety_limit--;
					}

					//Draw Rectangle
					var draw_x = rect.x
					var draw_y = rect.y
					while (draw_y <= rect.y2) {
						draw_x = rect.x
						while (draw_x <= rect.x2) {
							finishPixel(draw_x, draw_y)
							draw_x++;
						}
						draw_y++;
					}

					// Generate cube
					let from, to, faces;
					if (formResult.orientation == 'upright') {
						from = [rect.x * scale_i, 16 - (rect.y2 + 1) * scale_i, 0];
						to = [(rect.x2 + 1) * scale_i, 16 - rect.y * scale_i, scale_i];
						faces = {
							south: { uv: [rect.x * uv_scale_x, rect.y * uv_scale_y, (rect.x2 + 1) * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture },
							north: { uv: [(rect.x2 + 1) * uv_scale_x, rect.y * uv_scale_y, rect.x * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture },
							up: { uv: [rect.x * uv_scale_x, rect.y * uv_scale_y, (rect.x2 + 1) * uv_scale_x, (rect.y + 1) * uv_scale_y], texture: texture },
							down: { uv: [rect.x * uv_scale_x, rect.y2 * uv_scale_y, (rect.x2 + 1) * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture },
							east: { uv: [rect.x2 * uv_scale_x, rect.y * uv_scale_y, (rect.x2 + 1) * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture },
							west: { uv: [rect.x * uv_scale_x, rect.y * uv_scale_y, (rect.x + 1) * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture },
						};
					} else {
						from = [rect.x * scale_i, 0, rect.y * scale_i];
						to = [(rect.x2 + 1) * scale_i, scale_i, (rect.y2 + 1) * scale_i];
						faces = {
							up: { uv: [rect.x * uv_scale_x, rect.y * uv_scale_y, (rect.x2 + 1) * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture },
							down: { uv: [rect.x * uv_scale_x, (rect.y2 + 1) * uv_scale_y, (rect.x2 + 1) * uv_scale_x, rect.y * uv_scale_y], texture: texture },
							north: { uv: [(rect.x2 + 1) * uv_scale_x, rect.y * uv_scale_y, rect.x * uv_scale_x, (rect.y + 1) * uv_scale_y], texture: texture },
							south: { uv: [rect.x * uv_scale_x, rect.y2 * uv_scale_y, (rect.x2 + 1) * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture },
							east: { uv: [rect.x2 * uv_scale_x, rect.y * uv_scale_y, (rect.x2 + 1) * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture, rotation: 90 },
							west: { uv: [rect.x * uv_scale_x, rect.y * uv_scale_y, (rect.x + 1) * uv_scale_x, (rect.y2 + 1) * uv_scale_y], texture: texture, rotation: 270 },
						};
					}
					var current_cube = new Cube({
						name: cube_name + '_' + cube_nr,
						autouv: 0, box_uv: false,
						from, to, faces
					}).init();
					selected.push(current_cube);
					cube_nr++;
				}

				ext_x++;
			}
			ext_y++;
		}

		var group = new Group(cube_name).init().addTo()
		selected.forEach(function (s) {
			s.addTo(group).init()
		})

		Undo.finishEdit('Add extruded texture', { elements: selected, outliner: true, textures: [Texture.all[Texture.all.length - 1]] })
	}
}
//Export
function uploadSketchfabModel() {
	if (elements.length === 0 || !Format) {
		return;
	}
	let tag_suggestions = ['low-poly', 'pixel-art'];
	if (Format.id !== 'free') tag_suggestions.push('minecraft');
	if (Format.id === 'skin') tag_suggestions.push('skin');
	if (!Mesh.all.length) tag_suggestions.push('voxel');
	let clean_project_name = Project.name.toLowerCase().replace(/[_.-]+/g, '-').replace(/[^a-z0-9-]+/, '')
	if (Project.name) tag_suggestions.push(clean_project_name);
	if (clean_project_name.includes('-')) tag_suggestions.safePush(...clean_project_name.split('-').filter(s => s.length > 2 && s != 'geo').reverse());

	let categories = {
		"": "-",
		"animals-pets": "Animals & Pets",
		"architecture": "Architecture",
		"art-abstract": "Art & Abstract",
		"cars-vehicles": "Cars & Vehicles",
		"characters-creatures": "Characters & Creatures",
		"cultural-heritage-history": "Cultural Heritage & History",
		"electronics-gadgets": "Electronics & Gadgets",
		"fashion-style": "Fashion & Style",
		"food-drink": "Food & Drink",
		"furniture-home": "Furniture & Home",
		"music": "Music",
		"nature-plants": "Nature & Plants",
		"news-politics": "News & Politics",
		"people": "People",
		"places-travel": "Places & Travel",
		"science-technology": "Science & Technology",
		"sports-fitness": "Sports & Fitness",
		"weapons-military": "Weapons & Military",
	}

	var dialog = new Dialog({
		id: 'sketchfab_uploader',
		title: 'dialog.sketchfab_uploader.title',
		width: 640,
		form: {
			token: { label: 'dialog.sketchfab_uploader.token', value: settings.sketchfab_token.value, type: 'password' },
			about_token: { type: 'info', text: tl('dialog.sketchfab_uploader.about_token', ['[sketchfab.com/settings/password](https://sketchfab.com/settings/password)']) },
			name: { label: 'dialog.sketchfab_uploader.name', value: capitalizeFirstLetter(Project.name.replace(/\..+/, '').replace(/[_.-]/g, ' ')) },
			description: { label: 'dialog.sketchfab_uploader.description', type: 'textarea' },
			category1: { label: 'dialog.sketchfab_uploader.category', type: 'select', options: categories, value: '' },
			category2: { label: 'dialog.sketchfab_uploader.category2', type: 'select', options: categories, value: '' },
			tags: { label: 'dialog.sketchfab_uploader.tags', placeholder: 'Tag1 Tag2' },
			tag_suggestions: {
				label: 'dialog.sketchfab_uploader.suggested_tags', type: 'buttons', buttons: tag_suggestions, click(index) {
					let { tags } = dialog.getFormResult();
					let new_tag = tag_suggestions[index];
					if (!tags.split(/\s/g).includes(new_tag)) {
						tags += ' ' + new_tag;
						dialog.setFormValues({ tags });
					}
				}
			},
			animations: { label: 'dialog.sketchfab_uploader.animations', value: true, type: 'checkbox', condition: (Format.animation_mode && Animator.animations.length) },
			draft: { label: 'dialog.sketchfab_uploader.draft', type: 'checkbox', value: true },
			divider: '_',
			private: { label: 'dialog.sketchfab_uploader.private', type: 'checkbox' },
			password: { label: 'dialog.sketchfab_uploader.password' },
		},
		onConfirm: function (formResult) {

			if (formResult.token && !formResult.name) {
				Blockbench.showQuickMessage('message.sketchfab.name_or_token', 1800)
				return;
			}
			if (!formResult.tags.split(' ').includes('blockbench')) {
				formResult.tags += ' blockbench';
			}
			var data = new FormData()
			data.append('token', formResult.token)
			data.append('name', formResult.name)
			data.append('description', formResult.description)
			data.append('tags', formResult.tags)
			data.append('isPublished', !formResult.draft)
			//data.append('background', JSON.stringify({color: '#00ff00'}))
			data.append('private', formResult.private)
			data.append('password', formResult.password)
			data.append('source', 'blockbench')

			if (formResult.category1 || formResult.category2) {
				let selected_categories = [];
				if (formResult.category1) selected_categories.push(formResult.category1);
				if (formResult.category2) selected_categories.push(formResult.category2);
				data.append('categories', selected_categories);
			}

			settings.sketchfab_token.value = formResult.token

			Codecs.gltf.compile({ animations: formResult.animations }).then(content => {

				var blob = new Blob([content], { type: "text/plain;charset=utf-8" });
				var file = new File([blob], 'model.gltf')

				data.append('modelFile', file)

				$.ajax({
					url: 'https://api.sketchfab.com/v3/models',
					data: data,
					cache: false,
					contentType: false,
					processData: false,
					type: 'POST',
					success: function (response) {
						Blockbench.showMessageBox({
							title: tl('message.sketchfab.success'),
							message:
								`[${formResult.name} on Sketchfab](https://sketchfab.com/models/${response.uid})`, //\n\n&nbsp;\n\n`+
							icon: 'icon-sketchfab',
						})
					},
					error: function (response) {
						Blockbench.showQuickMessage(tl('message.sketchfab.error') + `Error ${response.status}`, 1500)
						console.error(response);
					}
				})
			})

			dialog.hide()
		}
	})
	dialog.show()
}
//Json
function compileJSON(object, options) {
	if (typeof options !== 'object') options = {}
	function newLine(tabs) {
		if (options.small === true) { return ''; }
		var s = '\n'
		for (var i = 0; i < tabs; i++) {
			s += '\t'
		}
		return s;
	}
	function escape(string) {
		return string.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n|\r\n/g, '\\n').replace(/\t/g, '\\t')
	}
	function handleVar(o, tabs, breaks = true) {
		var out = ''
		if (typeof o === 'string') {
			//String
			out += '"' + escape(o) + '"'
		} else if (typeof o === 'boolean') {
			//Boolean
			out += (o ? 'true' : 'false')
		} else if (o === null || o === Infinity || o === -Infinity) {
			//Null
			out += 'null'
		} else if (typeof o === 'number') {
			//Number
			o = (Math.round(o * 100000) / 100000).toString()
			out += o
		} else if (o instanceof Array) {
			//Array
			let has_content = false
			let multiline = !!o.find(item => typeof item === 'object');
			if (!multiline) {
				let length = 0;
				o.forEach(item => {
					length += typeof item === 'string' ? (item.length + 4) : 3;
				});
				if (length > 140) multiline = true;
			}
			out += '['
			for (var i = 0; i < o.length; i++) {
				var compiled = handleVar(o[i], tabs + 1)
				if (compiled) {
					if (has_content) { out += ',' + ((options.small || multiline) ? '' : ' ') }
					if (multiline) { out += newLine(tabs) }
					out += compiled
					has_content = true
				}
			}
			if (multiline) { out += newLine(tabs - 1) }
			out += ']'
		} else if (typeof o === 'object') {
			//Object
			breaks = breaks && o.constructor.name !== 'oneLiner';
			var has_content = false
			out += '{'
			for (var key in o) {
				if (o.hasOwnProperty(key)) {
					var compiled = handleVar(o[key], tabs + 1, breaks)
					if (compiled) {
						if (has_content) { out += ',' + (breaks || options.small ? '' : ' ') }
						if (breaks) { out += newLine(tabs) }
						out += '"' + escape(key) + '":' + (options.small === true ? '' : ' ')
						out += compiled
						has_content = true
					}
				}
			}
			if (breaks && has_content) { out += newLine(tabs - 1) }
			out += '}'
		}
		return out;
	}
	return handleVar(object, 1)
}
function autoParseJSON(data, feedback) {
	if (data.substr(0, 4) === '<lz>') {
		data = LZUTF8.decompress(data.substr(4), { inputEncoding: 'StorageBinaryString' })
	}
	if (data.charCodeAt(0) === 0xFEFF) {
		data = data.substr(1)
	}
	try {
		data = JSON.parse(data)
	} catch (err1) {
		data = data.replace(/\/\*[^(\*\/)]*\*\/|\/\/.*/g, '')
		try {
			data = JSON.parse(data)
		} catch (err) {
			if (feedback === false) return;
			function logErrantPart(whole, start, length) {
				var line = whole.substr(0, start).match(/\n/gm)
				line = line ? line.length + 1 : 1
				var result = '';
				var lines = whole.substr(start, length).split(/\n/gm)
				lines.forEach((s, i) => {
					result += `#${line + i} ${s}\n`
				})
				console.log(result.substr(0, result.length - 1) + ' <-- HERE')
			}
			console.error(err)
			var length = err.toString().split('at position ')[1]
			if (length) {
				length = parseInt(length)
				var start = limitNumber(length - 20, 0, Infinity)

				logErrantPart(data, start, 1 + length - start)
			} else if (err.toString().includes('Unexpected end of JSON input')) {

				logErrantPart(data, data.length - 10, 10)
			}
			Blockbench.showMessageBox({
				translateKey: 'invalid_file',
				icon: 'error',
				message: tl('message.invalid_file.message', [err])
			})
			return;
		}
	}
	return data;
}


BARS.defineActions(function () {
	//Import
	new Action('open_model', {
		icon: 'assessment',
		category: 'file',
		keybind: new Keybind({ key: 'o', ctrl: true }),
		click: function () {
			var startpath;
			if (isApp && recent_projects && recent_projects.length) {
				let first_recent_project = recent_projects.find(p => !p.favorite) || recent_projects[0];
				startpath = first_recent_project.path;
				if (typeof startpath == 'string') {
					startpath = startpath.replace(/[\\\/][^\\\/]+$/, '');
				}
			}
			Blockbench.import({
				resource_id: 'model',
				extensions: Codec.getAllExtensions(),
				type: 'Model',
				startpath,
				multiple: true
			}, function (files) {
				files.forEach(file => {
					loadModelFile(file);
				})
			})
		}
	})
	new Action('open_from_link', {
		icon: 'link',
		category: 'file',
		click() {
			Blockbench.textPrompt('action.open_from_link', '', link => {
				if (link.match(/https:\/\/blckbn.ch\//) || link.length == 4 || link.length == 6) {
					let code = link.replace(/\/$/, '').split('/').last();
					$.getJSON(`https://blckbn.ch/api/models/${code}`, (model) => {
						Codecs.project.load(model, { path: '' });
					}).fail(error => {
						Blockbench.showQuickMessage('message.invalid_link')
					})
				} else {
					$.getJSON(link, (model) => {
						Codecs.project.load(model, { path: '' });
					}).fail(error => {
						Blockbench.showQuickMessage('message.invalid_link')
					})
				}
			}, 'https://blckbn.ch/123abc')
		}
	})
	new Action('extrude_texture', {
		icon: 'eject',
		category: 'file',
		condition: _ => (Project && (!Project.box_uv || Format.optional_box_uv)),
		click() {
			Blockbench.import({
				resource_id: 'texture',
				extensions: ['png'],
				type: 'PNG Texture',
				readtype: 'image'
			}, (files) => {
				if (files.length) {
					Extruder.dialog.show();
					Extruder.drawImage(files[0]);
				}
			})
		}
	})
	//Export
	new Action('export_over', {
		icon: 'save',
		category: 'file',
		keybind: new Keybind({ key: 's', ctrl: true }),
		click: function () {
			if (isApp) {
				saveTextures()
				if (Format) {
					if (Project.save_path) {
						Codecs.project.write(Codecs.project.compile(), Project.save_path);
					}
					if (Project.export_path && Format.codec && Format.codec.compile) {
						Format.codec.write(Format.codec.compile(), Project.export_path)
					} else if (Format.codec && Format.codec.export && !Project.save_path) {
						Format.codec.export()
					} else if (!Project.save_path) {
						Project.saved = true;
					}
				}
				if (Format.animation_mode && Format.animation_files && Animation.all.length) {
					BarItems.save_all_animations.trigger();
				}
			} else {
				saveTextures()
				if (Format.codec && Format.codec.export) {
					Format.codec.export()
				}
			}
		}
	})
	if (!isApp) {
		new Action('export_asset_archive', {
			icon: 'archive',
			category: 'file',
			condition: _ => Format && Format.codec,
			click: function () {
				var archive = new JSZip();
				var content = Format.codec.compile()
				var name = `${Format.codec.fileName()}.${Format.codec.extension}`
				archive.file(name, content)
				Texture.all.forEach(tex => {
					if (tex.mode === 'bitmap') {
						archive.file(pathToName(tex.name) + '.png', tex.source.replace('data:image/png;base64,', ''), { base64: true });
					}
				})
				archive.generateAsync({ type: 'blob' }).then(content => {
					Blockbench.export({
						type: 'Zip Archive',
						extensions: ['zip'],
						name: 'assets',
						startpath: Project.export_path,
						content: content,
						savetype: 'zip'
					})
					Project.saved = true;
				})
			}
		})
	}
	new Action('upload_sketchfab', {
		icon: 'icon-sketchfab',
		category: 'file',
		click: function (ev) {
			uploadSketchfabModel()
		}
	})


	new Action('share_model', {
		icon: 'share',
		condition: () => Outliner.elements.length,
		async click() {
			let thumbnail = await new Promise(resolve => {
				Preview.selected.screenshot({ width: 640, height: 480 }, resolve);
			});
			let image = new Image();
			image.src = thumbnail;
			image.width = 320;
			image.style.display = 'block';
			image.style.margin = 'auto';
			image.style.backgroundColor = 'var(--color-back)';

			var dialog = new Dialog({
				id: 'share_model',
				title: 'dialog.share_model.title',
				form: {
					name: { type: 'text', label: 'generic.name', value: Project.name },
					expire_time: {
						label: 'dialog.share_model.expire_time', type: 'select', default: '2d', options: {
							'10m': tl('dates.minutes', [10]),
							'1h': tl('dates.hour', [1]),
							'1d': tl('dates.day', [1]),
							'2d': tl('dates.days', [2]),
							'1w': tl('dates.week', [1]),
							'2w': tl('dates.weeks', [2]),
						}
					},
					info: { type: 'info', text: 'The model and thumbnail will be stored on the Blockbench servers for the duration specified above. [Learn more](https://blockbench.net/blockbench-model-sharing-service/)' },
					thumbnail: { type: 'checkbox', label: 'dialog.share_model.thumbnail', value: true },
				},
				lines: [image],
				part_order: ['form', 'lines'],
				onFormChange(form) {
					image.style.display = form.thumbnail ? 'block' : 'none';
				},
				buttons: ['generic.share', 'dialog.cancel'],
				onConfirm: function (formResult) {

					let name = formResult.name;
					let expire_time = formResult.expire_time;
					let model = Codecs.project.compile({ compressed: false, absolute_paths: false });
					let data = { name, expire_time, model }
					if (formResult.thumbnail) data.thumbnail = thumbnail;

					$.ajax({
						url: 'https://blckbn.ch/api/model',
						data: JSON.stringify(data),
						cache: false,
						contentType: 'application/json; charset=utf-8',
						dataType: 'json',
						type: 'POST',
						success: function (response) {
							let link = `https://blckbn.ch/${response.id}`

							let link_dialog = new Dialog({
								id: 'share_model_link',
								title: 'dialog.share_model.title',
								form: {
									link: { type: 'text', value: link }
								},
								buttons: ['action.copy', 'dialog.close'],
								onConfirm() {
									link_dialog.hide();
									if (isApp || navigator.clipboard) {
										Clipbench.setText(link);
										Blockbench.showQuickMessage('dialog.share_model.copied_to_clipboard');
									} else {
										Blockbench.showMessageBox({
											title: 'dialog.share_model.title',
											message: `[${link}](${link})`,
										})
									}
								}
							}).show();

						},
						error: function (response) {
							Blockbench.showQuickMessage('dialog.share_model.failed', 1500)
							console.error(response);
						}
					})

					dialog.hide()
				}
			})
			dialog.show()
		}
	})



})
