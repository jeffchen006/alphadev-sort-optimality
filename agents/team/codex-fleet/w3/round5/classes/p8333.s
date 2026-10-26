# n=5 model=out iset=I1 prefix14_class=8333
cmp P3, P1
mov S0, P3
cmovl P3, P1
cmovg S0, P1
cmp P0, P2
cmovge P1, P2
cmovg P2, P0
cmovge P0, P1
cmp S0, P0
cmovle S1, S0
cmovle S0, P0
cmovg S1, P0
cmp P3, P2
cmovg S1, P3
