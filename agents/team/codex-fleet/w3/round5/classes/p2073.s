# n=5 model=out iset=I1 prefix14_class=2073
cmp P0, P1
mov S1, P0
cmovge P0, P1
cmovge P1, S1
mov S0, P3
cmp S0, P2
cmovg S0, P2
cmovg P2, P3
mov P3, P2
cmp P3, P1
cmovg P3, P1
cmovl P2, P1
cmp S0, P0
cmovle S1, S0
