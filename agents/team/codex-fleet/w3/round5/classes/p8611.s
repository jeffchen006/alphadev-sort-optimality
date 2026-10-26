# n=5 model=out iset=I1 prefix14_class=8611
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
cmovl P2, P0
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
mov S0, S1
cmovg P3, S2
cmp S1, P3
cmovg S0, P3
mov P0, P2
cmovge P3, S1
mov S1, S0
