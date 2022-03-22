filename = 'filters.txt'

with open(filename, 'r') as f:
    data = f.read().split('\n')

res = []
for i in data:
    for ii in i.split(' '):
        if ii:
            res.append(ii)

res.sort()
# with open(filename, 'w') as f:
#     f.write('')

with open(filename, 'w') as f:
    f.write('\n'.join(res))
    # for i in data:
    #     f.write(f'{i}\n')


# filename = 'demuxers.txt'

# with open(filename, 'r') as f:
#     data = f.read().split('\n')

# data.sort()
# with open(filename, 'w') as f:
#     f.write('')

# with open(filename, 'a') as f:
#     for i in data:
#         f.write(f'{i}\n')
