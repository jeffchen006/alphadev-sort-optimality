# n=5 model=out iset=I1 prefix14_class=5630
cmp P3, P0
cmovle S2, P0
cmovg S2, P3
cmovge P3, P0
cmp P2, P1
mov S0, P3
cmovle P0, P2
cmovl P2, P1
cmovle P1, P0
cmp S0, P1
cmovg P3, P1
cmovg P1, S0
cmp S2, P2
cmovge P3, S2
