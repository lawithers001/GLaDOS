import os
import sys


def main():
    os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'

    from django.core.management import execute_from_command_line
    from django.conf import settings
    import glados.static_files_compiler
    # Compress files before server launch if compression is enabled
    if os.environ.get('RUN_MAIN') != 'true' and len(sys.argv) > 1 and sys.argv[1] == 'runserver' and settings.DEBUG:
        glados.static_files_compiler.StaticFilesCompiler.compile_coffee()
        glados.static_files_compiler.StaticFilesCompiler.compile_scss()
        glados.static_files_compiler.enable_debug_logging()
        execute_from_command_line([sys.argv[0], 'compilemessages'])
    elif os.environ.get('RUN_MAIN') != 'true' and len(sys.argv) > 1 and sys.argv[1] == 'collectstatic':
        glados.static_files_compiler.StaticFilesCompiler.compile_coffee()
        glados.static_files_compiler.StaticFilesCompiler.compile_scss()
        execute_from_command_line([sys.argv[0], 'compilemessages', '--settings=glados'])
        if settings.COMPRESS_ENABLED and settings.COMPRESS_OFFLINE:
            execute_from_command_line([sys.argv[0], 'compress'])
    execute_from_command_line(sys.argv)


if __name__ == "__main__":
    main()
