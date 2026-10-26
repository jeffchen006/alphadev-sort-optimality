# n=5 model=out iset=I1 prefix14_class=2855
cmp P0, P3
cmovge S0, P0
cmovge P0, P3
cmovg P3, S0
cmp P1, P2
mov S0, P1
mov S1, P3
cmovg P1, P2
cmovl S0, P2
cmp S0, S1
cmovge S1, S0
cmovg S0, P3
cmp P0, P1
cmovle P2, P0
