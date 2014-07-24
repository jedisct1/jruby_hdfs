module Hdfs

  require "delegate"
  
  # Provides access to a HDFS cluster by mimicking Ruby's ::IO and ::File API
  # _file_ is basically a wrapper for the underlying HDFS stream as a Ruby IO stream.
  #
  class File < Delegator
    
    def initialize(path, mode = 'r', fs = Hdfs.fs)

      @fs = fs
      
      _mode = self.class.parse_mode(mode)
      
      if _mode & IO::RDWR != 0
        @readable = true
        @writable = true
      elsif _mode & IO::WRONLY != 0
        @writable = true
      else # IO::RDONLY
        @readable = true
      end
      
      if @readable
        raise Errno::ENOENT, "File does not exist" unless  File.exists?(path)
        raise Errno::ENOENT, "File not a regular file" unless File.file?(path)
      end
    
      @stream = @fs.open(path,@writable)
    end
    
    def writable?
      @writeable
    end
    
    def self.open(*args)
      f = File.new(*args) if args.length > 0 && args.length < 4

      if block_given?
        begin
          yield f
        ensure
          f.close
        end
      end
      f
    end
    
    def self.close
      Hdfs.fs.close
    end
    
    def self.exists?(path)
      Hdfs.fs.exists?(path)
    end
    
    def self.file?(path)
      Hdfs.fs.file?(path)
    end
    
    def self.size(path)
      Hdfs.fs.size(path)
    end
    

    def self.directory?(path)
      Hdfs.fs.directory?(path)
    end
    
    # will always return => false
    def self.chardev?(path); false; end
    # will always return => false
    def self.blockdev?(path); false; end
    # will always return => false
    def self.executable?(path); false; end
    # will always return => false
    def self.executable_real?(path); false; end

    def self.dir(path)
      Hdfs.fs.dir(path)
    end

    def self.delete(path, recursive = FALSE)
      Hdfs.fs.delete(path, recursive)
    end

    class << self
       alias_method :exist?, :exists?
    end
    
    # :nodoc:
    
    def __getobj__
      @stream
    end
    
    def __setobj__(obj)
      @stream = obj
    end
    
    def self.parse_mode(mode)
      ret = 0
    
      case mode[0]
        when ?r
          ret |= IO::RDONLY
        when ?w
          ret |= IO::WRONLY | IO::CREAT | IO::TRUNC
        when ?a
          ret |= IO::WRONLY | IO::CREAT | IO::APPEND
        else
          raise ArgumentError, "invalid mode -- #{mode}"
      end
    
      return ret if mode.length == 1
    
      case mode[1]
        when ?+
          ret &= ~(IO::RDONLY | IO::WRONLY)
          ret |= IO::RDWR
        when ?b
          ret |= IO::BINARY
        when ?:
          warn("encoding options not supported in 1.8")
          return ret
        else
          raise ArgumentError, "invalid mode -- #{mode}"
      end
    
      return ret if mode.length == 2
    
      case mode[2]
        when ?+
          ret &= ~(IO::RDONLY | IO::WRONLY)
          ret |= IO::RDWR
        when ?b
          ret |= IO::BINARY
        when ?:
          warn("encoding options not supported in 1.8")
          return ret
        else
          raise ArgumentError, "invalid mode -- #{mode}"
      end
    
      ret
      
    end
    
  end
    
end
