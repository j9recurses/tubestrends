def procdir_dir(dir)
  Dir[ File.join(dir, '**', '*') ].reject { |p| !File.directory? p }
end

def procdir_fil(dir)
  Dir[ File.join(dir, '**', '*.json') ].reject { |p| File.directory? p }
end

def ch_directory_exists(directory)
  cool = File.directory?(directory)
  if not cool
    require 'fileutils'
    FileUtils::mkdir_p directory
  end
end

def replaceFileContents( path, patternToReplace, newProjectName )
  fileContents = File.read ( path )
  fileContents = fileContents.gsub( patternToReplace, newProjectName )
  File.open( path, 'w' ) { | file | file.puts fileContents }
end
def packageInitiator( startDirectory, patternToReplace, newProjectName )
  directoryItems = Dir.glob( startDirectory ).reverse
  directoryItems.each do | path |

    # ignoring ruby scripts so I don't change contents of this file
    if( FileTest.file? ( path ) and File.extname( path ) != '.rb' )
      replaceFileContents( path, patternToReplace, newProjectName )
    end

    if( path.include? patternToReplace )
      oldPath = File.dirname(path)
      newPath = oldPath + '/' + File.basename( path ).gsub( patternToReplace, newProjectName )
      File.rename( path, newPath )
    end
  end
end


def make_combine(myfiles, mydir_out)
  counter = 0
  myfiles.each do |fname|
    fstuff = fname.split("/")
    fsize = fstuff.size
    fstr = fstuff[fsize-1]
    daydirfile = fstuff[fsize-2]
    daydir = fstuff[fsize-2] + "_combined/"
    ##make the dirs
    ch_directory_exists(mydir_out)
    ch_directory_exists(mydir_out + daydir)
    fstuff.pop
    fgood = fstr.split("_")
    if fgood[0] == "twitter"
      finalfname = mydir_out + daydir + fgood[0] + "_" + fgood[1] + "_"+  daydirfile + "_combined.json"
    else
      fgood.pop
      finalfname = mydir_out + daydir + fgood.join("_") + "_combined.json"
    end
    if counter == 0 and   File.exist? finalfname
      counter = counter + 1
      break
    else
      #remove any remaining "''" chars
      packageInitiator( fname, "'", "" )
      f = File.new(finalfname, "a+")
      f_in = File.open(fname, "r")
      f_in.each {|f_str| f.puts(f_str) }
      f_in.close
      f.close
      counter =  counter + 1
    end
  end

end


mydir = "/mnt/s3/tubes_trends_orig/json_data/*"
mydirout = "/mnt/s3/tubes_trends_orig/combined_data_json/"
#mydir = "/home/j9/spring/tubestrends/sample/tubes_trends/*"
#mydirout = "all/"


cooldirs =  procdir_dir(mydir)
cooldirs.each do |d|
  myfiles = procdir_fil(d)
  make_combine(myfiles, mydirout)
end

