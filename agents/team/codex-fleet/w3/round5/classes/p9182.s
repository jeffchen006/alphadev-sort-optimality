# n=5 model=out iset=I1 prefix14_class=9182
mov S2, P0
mov S0, P2
cmp P3, S0
cmovge S0, P3
cmovl P2, P3
cmp P1, S2
cmovle P0, P1
cmovle P1, S2
cmp P0, P2
cmovg S2, P0
cmovge P0, P2
cmovg P2, S2
mov P3, P1
cmp S0, P3
