require "delegate"

module Hdfs
  
  # Wrapper for a org.apache.hadoop.fs.FileSystem
  # shall not be used directly but via Hdfs::File
  class FileSystem < Delegator
    import org.apache.hadoop.conf.Configuration
    import org.apache.hadoop.fs.FileSystem
    
    def initialize(conf = Configuration.new)
      @fs=org.apache.hadoop.fs.FileSystem.get(conf)
    end
    
    def exists?(path)
      path = coerce_path path
      @fs.exists(path.path)
    end
    
    def file?(path)
      path = coerce_path path
      @fs.isFile(path.path)
    end

    
    def size(path)
      path = coerce_path path
      @fs.getFileStatus(path.path).getLen()
    end
    
    def open(path, writable=false)
      path = coerce_path path
      unless writable
        @fs.open(path.path).to_io
      else
        @fs.create(path.path).to_io
      end
    end
    
    def directory?(path)
      path = coerce_path path
      @fs.getFileStatus(path.path).isDir
    end

    # From the Hadoop API docs:
    # No more filesystem operations are needed. Will release any held locks.
    def close
      @fs.close
    end

    def dir(path)
      path = coerce_path path
      @fs.listStatus(path.path).map { |path| path.path }
    end

    def delete(path, recursive = FALSE)
      @fs.delete(path.path, recursive)
    end

    def __getobj__
      @fs
    end
    
    def __setobj__(obj)
      @fs = obj
    end
    
    private
    def coerce_path(path)
      Path.new(path) unless path.is_a? Path
    end
    
    
    
  end

end
