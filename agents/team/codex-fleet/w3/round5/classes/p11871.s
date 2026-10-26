# n=5 model=out iset=I1 prefix14_class=11871
cmp P0, P1
mov S2, P1
cmovle S2, P0
cmovge P1, P0
mov S0, P3
cmp S0, P2
cmovg S0, P2
cmovl P3, P2
cmp P3, P1
cmovle P0, P3
cmovle P3, P1
cmovle P1, P0
cmp S2, S0
cmovg P2, S2
