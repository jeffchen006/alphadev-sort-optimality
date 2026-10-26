# n=5 model=out iset=I1 prefix14_class=9871
cmp P1, P0
cmovge S2, P0
cmovge P0, P1
mov S0, P3
cmovg P1, S2
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
cmp S0, P0
cmovle S1, P0
cmovg S1, S0
cmovg S0, P0
cmovl P0, S0
cmp P1, P2
