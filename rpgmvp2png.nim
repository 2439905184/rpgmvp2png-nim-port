import std/os
import std/strutils

proc decryptRpgmvp(inputFile: string, outputFile: string) = 
  const PngHeader = "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52"
  var fileIn = open(inputFile, fmRead)
  var data = fileIn.readAll()
  var fileOut = open(outputFile, fmWrite)
  fileOut.write(PngHeader)
  fileOut.write(data[32..^1])
  fileIn.close()
  fileOut.close()

proc decryptDirectory(directory:string) = 
   # 获取输入目录的基本名称
  let baseDir = splitPath(directory).tail
  # 在当前工作目录下创建同名的输出目录
  let outputDir = joinPath(getCurrentDir(), baseDir)
  
  # 确保输出目录存在
  createDir(outputDir)
  
  # 遍历输入目录下的所有文件和子目录
  for filePath in walkDirRec(directory, yieldFilter = {pcFile}):
    if filePath.endsWith(".rpgmvp"):
      # 获取输入文件相对于输入目录的相对路径
      let relativePath = relativePath(filePath, directory, '/')
      
      # 获取输出文件的子目录路径
      let outputSubdir = parentDir(relativePath)
      
      # 构建输出文件的文件名(将扩展名改为.png)
      let fileName = relativePath.extractFilename()
      let outputFile = changeFileExt(fileName, "png")
      
      # 构建输出文件的完整目录路径
      let outputPath = joinPath(outputDir, outputSubdir)
      
      # 创建输出文件的目录(如果不存在)
      createDir(outputPath)
      
      # 构建输出文件的完整路径
      let outputFilePath = joinPath(outputPath, extractFilename(outputFile))
      
      # 调用decryptRpgmvp函数解密单个文件]#
      decryptRpgmvp(filePath, outputFilePath)

var args = commandLineParams()
if len(args) == 2:
  var inputFile = args[0]
  var outputFile = args[1]
  decryptRpgmvp(inputFile, outputFile)
elif len(args) == 1:
  var path = args[0]
  if dirExists(path):
    if fileExists(path):
      echo "Error: '" & path & "' is a file, not a directory."
    else:
      decryptDirectory(path)
  else:
    echo "Error: Path '" & path & "' does not exist."
else:
# 编译时检查系统
  if defined(windows):
    echo("Usage:")
    echo("  For single file:rpgmvp2png.exe input.rpgmvp output.png")
    echo("  For entire directory: rpgmvp2png.exe directory_path")
  else:
    echo("Usage:")
    echo("  For single file:rpgmvp2png.arm input.rpgmvp output.png")
    echo("  For entire directory: rpgmvp2png.arm directory_path")