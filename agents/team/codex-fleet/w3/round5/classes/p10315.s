# n=5 model=out iset=I1 prefix14_class=10315
mov S1, P3
cmp P1, P3
cmovl P3, P1
cmovg S1, P1
mov S0, P2
cmp P0, P2
cmovle S0, P0
cmovg P2, P0
cmp S1, P2
cmovge P1, P2
cmovge P2, S1
cmovge S1, P1
cmp S0, P3
cmovg P0, S0
