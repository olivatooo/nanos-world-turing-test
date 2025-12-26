OST = nil

function PlayWooshAt(location)
	Sound(
		location,
		"package://turing-test/Client/SFX/whosh.ogg",
		false, -- Is 2D Sound
		true, -- Auto Destroy (if to destroy after finished playing)
		SoundType.SFX,
		1, -- Volume
		RandomFloat(0.8, 1.2), -- Pitch
		1000,
		2000,
		AttenuationFunction.NaturalSound
	)
end

function PlaySFXAt(location, sfx)
	Sound(
		location,
		"package://turing-test/Client/SFX/" .. sfx,
		false, -- Is 2D Sound
		true, -- Auto Destroy (if to destroy after finished playing)
		SoundType.SFX,
		1, -- Volume
		RandomFloat(0.8, 1.2), -- Pitch
		2000,
		10000,
		AttenuationFunction.NaturalSound
	)
end

function PlayNanosSFXAt(location, sfx)
	Sound(
		location,
		"nanos-world::" .. sfx,
		false, -- Is 2D Sound
		true, -- Auto Destroy (if to destroy after finished playing)
		SoundType.SFX,
		1, -- Volume
		RandomFloat(0.8, 1.2), -- Pitch
		2000,
		10000,
		AttenuationFunction.NaturalSound
	)
end

function PlayOST(number)
	Console.Log("Playing OST " .. number)
	if OST ~= nil and OST:IsPlaying() then
		OST:Stop()
	end
	OST = Sound(
		Vector(),
		"package://turing-test/Client/Music/" .. number .. ".ogg",
		true, -- Is 2D Sound
		false, -- Auto Destroy (if to destroy after finished playing)
		SoundType.Music,
		1, -- Volume
		1,
		nil,
		nil,
		nil,
		nil,
		SoundLoopMode.Forever
	)
end

function PlayMusic(song)
	Console.Log("Playing Music")
	if OST ~= nil and OST:IsPlaying() then
		OST:Stop()
	end
	OST = Sound(
		Vector(),
		"package://turing-test/Client/Music/" .. song .. ".ogg",
		true,
		false,
		SoundType.Music,
		0.33,
		1,
		nil,
		nil,
		nil,
		nil,
		SoundLoopMode.Never
	)
end

function PlayTauntAt(location, number)
	Sound(
		location,
		"package://turing-test/Client/SFX/taunt_" .. number .. ".ogg",
		false, -- Is 2D Sound
		true, -- Auto Destroy (if to destroy after finished playing)
		SoundType.SFX,
		1, -- Volume
		1, -- Pitch
		500,
		1000,
		AttenuationFunction.NaturalSound
	)
end

Events.SubscribeRemote("PlayTauntAt", PlayTauntAt)
Events.SubscribeRemote("PlayOST", PlayOST)
Events.SubscribeRemote("PlaySFXAt", PlaySFXAt)
Events.SubscribeRemote("WOOSH", PlayWooshAt)
Events.SubscribeRemote("PlayNanosSFXAt", PlayNanosSFXAt)
PlayOST(math.random(1, 9))
