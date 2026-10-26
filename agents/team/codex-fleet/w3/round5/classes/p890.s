# n=5 model=out iset=I1 prefix14_class=890
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P1, P0
mov S1, P0
cmovg P0, P1
mov S0, P0
cmovl S1, P1
cmp P2, P0
cmovg P0, P2
mov P0, P3
cmovle S0, P2
cmp P0, S1
