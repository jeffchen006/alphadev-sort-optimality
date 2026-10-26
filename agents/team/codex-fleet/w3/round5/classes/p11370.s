# n=5 model=out iset=I1 prefix14_class=11370
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
mov S0, P0
cmovl P2, S2
cmp S0, P1
cmovle P0, P1
cmovg S0, P1
cmp P2, P0
cmovge P1, P0
cmovg P0, P2
cmovge P2, P1
cmp S0, P3
cmovge S2, P3
