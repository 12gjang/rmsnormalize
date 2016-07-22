import sys
from vst2preset import vst2preset

TEMPLATE = "L3.fxp"
THRESHOLD_PLACEHOLDER = "-0.69999999999999996"
THRESHOLD = sys.argv[1]
OUTFILE = sys.argv[2]

preset = vst2preset.parse(open(TEMPLATE).read())
size = preset['byteSize']
data_size = preset['data']['size']

preset['data']['chunk'] = \
  preset['data']['chunk'].replace(THRESHOLD_PLACEHOLDER, THRESHOLD)
preset['data']['size'] = len(preset['data']['chunk'])
byte_size_diff = preset['data']['size'] - data_size
preset['byteSize'] += byte_size_diff


with open(OUTFILE, 'wb') as outfile:
  outfile.write(vst2preset.build(preset))



