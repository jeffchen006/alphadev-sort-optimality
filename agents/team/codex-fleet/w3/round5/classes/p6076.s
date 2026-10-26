# n=5 model=out iset=I1 prefix14_class=6076
cmp P3, P2
cmovg S1, P3
cmovle S1, P2
cmovle P2, P3
cmp P1, P0
mov P3, P1
cmovl P1, P0
mov S0, P1
cmovg P3, P0
cmp S0, S1
cmovge P1, S1
cmovge S1, S0
cmp P2, P3
cmovge S0, P2
