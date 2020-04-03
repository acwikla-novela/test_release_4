version = '0.1.001'
print(version)


from setuptools import setup, find_packages


setup(
    name='test_release_4',
    version=version,
    author='Aleksander Cwikla',
    url="https://github.com/acwikla-novela/test_release_4",
    packages=find_packages(),
    description='TestingHowToAutomateRelease',
    platforms='Posix; MacOS X; Windows',
    python_requires='==3.7.4',
)
