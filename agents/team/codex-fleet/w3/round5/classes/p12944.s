# n=5 model=out iset=I1 prefix14_class=12944
mov S0, P3
cmp P1, S0
cmovg P3, P1
cmovge P1, S0
mov S2, P0
cmp P2, S2
cmovg P0, P2
cmovle S2, P2
cmp P1, S2
mov S1, P3
cmovl S0, P1
cmovle P1, S2
cmovl S2, S0
cmp P0, P3
