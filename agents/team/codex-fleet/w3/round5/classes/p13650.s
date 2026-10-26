# n=5 model=out iset=I1 prefix14_class=13650
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
cmovle S1, P1
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P0, P3
cmovge P1, P3
cmovle P1, P0
cmovle P0, P3
cmp S1, P2
cmovl S2, S1
