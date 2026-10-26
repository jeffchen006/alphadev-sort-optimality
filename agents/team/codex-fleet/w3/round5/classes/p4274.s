# n=5 model=out iset=I1 prefix14_class=4274
cmp P3, P0
cmovge S1, P3
cmovle S1, P0
cmovge P3, P0
mov P0, P1
cmp P1, P2
cmovge P1, P2
cmovge P2, P0
cmp P1, P3
cmovl P0, P3
cmovle P3, P1
cmovl P1, P0
cmp P2, S1
mov P3, S1
