# n=5 model=out iset=I1 prefix14_class=392
cmp P2, P1
cmovge S2, P2
mov S0, P3
cmovle S2, P1
cmovl P1, P2
cmp S0, P0
cmovge P3, P0
cmovg P0, S0
mov S1, P3
cmp S1, P1
cmovle S1, P1
cmovg P3, P1
cmp S2, P0
mov P3, P0
