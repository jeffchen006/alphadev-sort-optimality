# n=5 model=out iset=I1 prefix14_class=5926
cmp P3, P0
mov S0, P2
mov S2, P3
cmovle S2, P0
cmovg P3, P0
cmp P1, S0
cmovle S0, P1
cmovg P2, P1
cmp S2, P2
cmovl P0, S2
cmovle S2, P2
cmovl P2, P0
mov P1, P3
cmp P3, S0
