# n=5 model=out iset=I1 prefix14_class=5082
mov S0, P3
mov S2, P1
cmp P1, P2
cmovl P1, P2
cmovg S2, P2
cmp P3, P0
cmovge P3, P0
cmovg P0, S0
cmp S2, P3
mov S1, P3
cmovg P3, S2
cmovle S1, S2
mov S1, P1
cmp P1, P0
