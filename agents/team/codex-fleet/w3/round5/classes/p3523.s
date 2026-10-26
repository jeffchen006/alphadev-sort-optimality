# n=5 model=out iset=I1 prefix14_class=3523
mov S1, P1
cmp P1, P3
cmovg P1, P3
cmovge P3, S1
mov S1, P1
cmp P2, P0
cmovg S0, P2
cmovle S0, P0
cmovl P0, P2
cmp P0, S1
cmovge S1, P0
cmovle P1, P0
cmp S0, P3
cmovge P1, P3
