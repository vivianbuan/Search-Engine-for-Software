"""
A simple Python script to generate queries about software packages to Slant

To run this script, run the command:
python generate_queries.py <path/to/output.txt>
"""
import sys


def main():
    # List of common languages
    language_list = ['javascript', 'python', 'java', 'ruby', 'php', 'go',
                     'c++', 'c', 'c#', 'typescript', 'shell', 'scala', 'swift',
                     'dm', 'rust', 'objective-c', 'coffeescript', 'haskell',
                     'groovy', 'lua']

    # List of common programming tasks
    task_list = ['visualization', 'scientific computing', 'machine learning',
                 'game design', 'game development', 'database', 'big data',
                 'blockchain', 'web development', 'UI', 'UX', 'graphics',
                 'simulation', 'modeling', 'artificial intelligence',
                 'sysadmin', 'firmware', 'iot', 'backend', 'embedded',
                 'emulators', 'virtualization', 'networking', 'security'
                 'processor design', 'OS development', 'cloud',
                 'signal processing', 'image processing', 'computer vision',
                 'data analytics', 'natural language processing',
                 'recommendation systems']

    # List of common OS
    os_list = ['windows', 'mac', 'linux']

    # Combinatorially create query strings and output to file
    txt_filepath = sys.argv[1]
    with open(txt_filepath, 'w') as f:
        for language in language_list:
            for task in task_list:
                for os in os_list:
                    cur_seq = (language, task, os)
                    f.write(str.join(' ', cur_seq) + '\n')


if __name__ == "__main__":
    main()
