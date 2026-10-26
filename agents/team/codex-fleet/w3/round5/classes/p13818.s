# n=5 model=out iset=I1 prefix14_class=13818
mov S0, P2
mov S2, P3
cmp S0, P1
cmovg P2, P1
cmovl S0, P1
cmp P0, P3
cmovle P3, P0
cmovg S2, P0
cmp S2, S0
cmovge P1, S0
cmovge S0, S2
cmovge S2, P1
mov S0, P2
cmp P3, S0
