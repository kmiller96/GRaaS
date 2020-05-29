from setuptools import setup, find_packages

setup(
    name='GRaaS',
    version='0.1dev',
    packages=find_packages(),
    entry_points={
        'console_scripts': ['graas=src.cli.__main__:main'],
    },
    long_description=open('README.md').read(),
    long_description_content_type="text/markdown"
)