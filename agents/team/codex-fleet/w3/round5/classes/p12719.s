# n=5 model=out iset=I1 prefix14_class=12719
mov S0, P3
cmp P3, P0
cmovle S0, P0
cmovge P3, P0
cmp P1, P2
cmovle S2, P1
cmovl P1, P2
cmovl P2, S2
cmp P2, P3
mov S1, P3
cmovg S1, P2
cmovg P2, P3
cmp S0, P1
mov P3, S0
