from progressbar import ProgressBar, Percentage, Bar

# need to explicitly clear output when using iPython
try:
    from IPython.core.display import clear_output
    use_iPython = True
except ImportError:
    use_iPython = False

class Progress(object):
    def __init__(self, maxVal):        
        self.bar = ProgressBar(widgets = [Percentage(), Bar()], maxval = maxVal).start()
    
    def update(self, newVal):
        # clear output if using iPython
        if use_iPython:
            clear_output()
        
        self.bar.update(newVal)
    
    def close(self):
        if use_iPython:
            clear_output()
            
        self.bar.finish()