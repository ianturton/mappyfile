import os, logging
import pytest
import mappyfile
from mappyfile.parser import Parser
from mappyfile.transformer import MapfileToDict

def test_all_maps():

    sample_dir = os.path.join(os.path.dirname(__file__), "sample_maps")

    #p = Parser(expand_includes=False, add_linebreaks=False)

    for fn in sorted(os.listdir(sample_dir)):
        if fn == "rfc14.map":
            p = Parser(expand_includes=False, add_linebreaks=False)
            print(fn)
            try:
                ast = p.parse_file(os.path.join(sample_dir, fn))
                #ast.to_png_with_pydot(r'C:\Temp\Trees\%s.png' % os.path.basename(fn))
            except Exception as ex:
                logging.warning("Cannot process %s ", fn)
                logging.error(ex)
                #raise

def test_includes():
    p = Parser()
   
    ast = p.parse_file('./tests/samples/include1.map')
    m = MapfileToDict()

    d = (m.transform(ast)) # works
    print(mappyfile.dumps(d))

def run_tests():        
    pytest.main(["tests/test_sample_maps.py"])

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    test_all_maps()
    #run_tests()
    print("Done!")