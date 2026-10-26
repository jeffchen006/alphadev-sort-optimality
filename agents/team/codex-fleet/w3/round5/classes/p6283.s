# n=5 model=out iset=I1 prefix14_class=6283
mov S1, P2
cmp S1, P3
cmovge P2, P3
mov S0, P1
cmovge P3, S1
cmp P0, S0
cmovg S0, P0
cmovge P0, P1
cmovge P1, S0
cmp P1, P3
cmovle S0, P3
cmovge P1, P3
cmp P0, P2
cmovl P3, P1
