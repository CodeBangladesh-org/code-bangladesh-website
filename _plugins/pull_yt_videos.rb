module PullYtVideosPlugin

  class Generator < Jekyll::Generator
    priority :lowest
    def generate(site)
      Yt.configuration.api_key = ENV["CB_YT_API_KEY"]
      categories = Common.read_categories(site)
      categories.each do | category |
        courses = Common.read_category_courses(site, category["id"])
        courses.each do | course |
          first_video_link = course["content"][0]["video_link"]
          if first_video_link.include? "playlist"
            yt_playlist_id = first_video_link[38..]
            playlist = Yt::Playlist.new id: yt_playlist_id
            file_content = ""
            playlist.playlist_items.each do | playlist_item |
              file_content += "\n#  - name: " + playlist_item.title + "\n"
              file_content += "#    video_link: https://www.youtube.com/watch?v=" + playlist_item.video_id + "\n"
              file_content += "#    description: এটি একটি ভিডিও লিঙ্ক, সরাসরি ইউটিউবে চলে যাবে।\n"
            end
            Common.append_to_file("_data/courses/" + category["id"] + "/" + course["filename"], file_content)
          end
        end
        end
    end
  end
end
