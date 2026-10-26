# n=5 model=out iset=I1 prefix14_class=5040
mov S2, P1
cmp P0, S2
mov S0, P2
cmovle S2, P0
cmovg P1, P0
cmp P3, P2
cmovl S0, P3
cmovg P2, P3
cmp S2, S0
cmovge P0, S0
cmovl P0, S2
cmovg S0, S2
cmp P1, P2
cmovle S2, P2
