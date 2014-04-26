module Iqdb
  class Importer
    def import!
      Post.find_each do |post|
        # IO.popen("iqdb command #{Danbooru.config.iqdb_file}", "w+") do |io|
          if File.exists?(post.preview_file_path)
            hex = post.id.to_s(16)
            puts "add 0 #{hex}:#{post.preview_file_path}"
            # puts "quit"
          end
        # end
      end
    end
  end
end
