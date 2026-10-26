# n=5 model=out iset=I1 prefix14_class=9497
cmp P2, P3
cmovle S1, P3
mov S0, P1
cmovl P3, P2
cmovge S1, P2
cmp P0, P1
cmovg S0, P0
cmovg P0, P1
mov P1, P0
cmp P1, P3
cmovge P1, P3
cmovle P0, P3
cmp S0, S1
cmovle P3, S0
