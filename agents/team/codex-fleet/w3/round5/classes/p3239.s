# n=5 model=out iset=I1 prefix14_class=3239
cmp P3, P0
mov S0, P3
cmovle S0, P0
cmovge P3, P0
mov S1, P2
cmp P1, S1
cmovg S1, P1
cmovge P1, P2
cmovl P2, P1
cmp P2, P3
cmovl P1, P3
cmovg P2, P3
mov P3, S0
cmp S1, P3
