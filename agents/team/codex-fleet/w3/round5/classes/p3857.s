# n=5 model=out iset=I1 prefix14_class=3857
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
cmovg P2, S2
cmp P3, P1
mov S2, P0
mov S0, P3
cmovl S0, P1
cmovl P1, P3
cmp S2, P1
cmovle P0, P1
cmovle P1, S2
cmp S0, P2
cmovle S2, S0
