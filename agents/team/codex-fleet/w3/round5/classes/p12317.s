# n=5 model=out iset=I1 prefix14_class=12317
cmp P1, P0
mov S1, P2
cmovge S0, P1
cmovg P1, P0
cmovge P0, S0
cmp S1, P3
cmovl P2, P3
cmovle P3, S1
cmp P3, P1
mov S1, P1
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
cmovg S0, P2
