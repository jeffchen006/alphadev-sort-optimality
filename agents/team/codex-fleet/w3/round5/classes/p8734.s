# n=5 model=out iset=I1 prefix14_class=8734
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovg P2, P0
cmp P3, P1
cmovge P0, P3
cmovl P0, P1
cmovle P1, P3
cmp S1, P0
cmovl S0, P0
cmovle P0, S1
cmovl S1, S0
cmp P2, P1
cmovg S1, P2
