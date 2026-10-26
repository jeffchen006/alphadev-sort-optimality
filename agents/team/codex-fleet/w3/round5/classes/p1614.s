# n=5 model=out iset=I1 prefix14_class=1614
mov S2, P0
cmp P0, P2
cmovge P0, P2
cmovle S2, P2
mov S0, P1
cmp P3, P1
cmovl S0, P3
cmovg P1, P3
cmovg P3, S0
cmp P0, S0
cmovl P3, P0
cmovl P0, S0
cmp S2, P1
mov S0, P1
