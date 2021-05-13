MusicManager = Object:extend()

function MusicManager:new(song_list, music_tag)
    self.song_list = song_list
    self.music_tag = music_tag
    self.track_index = 1
end

function MusicManager:setVolume(volume)
    assert(volume >=0 and volume <= 1, "Volume out of range")
    self.music_tag.volume = volume
end

function MusicManager:getVolume()
    return self.music_tag.volume
end

function MusicManager:play()
    self.song_list[1].song:play()
end

function MusicManager:stop()
    self.song_list[1].stop:play()
end