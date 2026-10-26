# n=5 model=out iset=I1 prefix14_class=12026
mov S2, P3
cmp P2, P1
cmovg S0, P2
cmovg P2, P1
cmovg P1, S0
cmp P0, P3
cmovl S2, P0
mov S1, S2
cmovl P0, P3
cmp S2, P2
cmovg S1, P2
cmovge P2, S2
cmp P0, P1
cmovle S0, P1
