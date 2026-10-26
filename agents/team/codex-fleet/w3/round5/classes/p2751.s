# n=5 model=out iset=I1 prefix14_class=2751
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovge P1, P3
mov P3, P0
cmp P3, P2
cmovle P0, P2
cmovg P3, P2
mov S2, P0
cmp S1, S2
cmovle P0, S1
cmovle S1, S2
cmp P3, P1
cmovle P2, P3
