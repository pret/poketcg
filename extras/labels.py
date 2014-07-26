# -*- coding: utf-8 -*-
"""
Various label/line-related functions.
"""

import os

class Labels(object):
    """
    Store all labels.
    """

    def __init__(self, config, filename="tcg.map"):
        """
        Setup the instance.
        """
        self.config = config
        self.filename = filename
        self.path = os.path.join(self.config.path, self.filename)

    def initialize(self):
        """
        Handle anything requiring file-loading and such.
        """
        # Look for a mapfile if it's not given
        if not os.path.exists(self.path):
            self.filename = find_mapfile_in_dir(self.config.path)
            if self.filename == None:
                raise Exception, "Couldn't find any mapfiles. Run rgblink -m to create a mapfile."
            self.path = os.path.join(self.config.path, self.filename)

        self.labels = read_mapfile(self.path)

def find_mapfile_in_dir(path):
    for filename in os.listdir(path):
        if os.path.splitext(filename)[1] == '.map':
            return filename
    return None

def read_mapfile(filename='tcg.map'):
    """
    Scrape label addresses from an rgbds mapfile.
    """

    labels = []

    with open(filename, 'r') as mapfile:
        lines = mapfile.readlines()

    for line in lines:
        if line[0].strip(): # section type def
            section_type = line.split(' ')[0]
            if section_type == 'Bank': # ROM
                cur_bank = int(line.split(' ')[1].split(':')[0][1:])
            elif section_type in ['WRAM0', 'HRAM']:
                cur_bank = 0
            elif section_type in ['WRAM, VRAM']:
                cur_bank = int(line.split(' ')[2].split(':')[0][1:])
                cur_bank = int(line.split(' ')[2].split(':')[0][1:])

        # label definition
        elif '=' in line:
            address, label = line.split('=')
            address = int(address.lstrip().replace('$', '0x'), 16)
            label = label.strip()

            bank = cur_bank
            offset = address
            if address < 0x8000 and bank: # ROM
                offset += (bank - 1) * 0x4000

            labels += [{
                'label': label,
                'bank': bank,
                'address': offset,
                'offset': offset,
                'local_address': address,
            }]

    return labels

