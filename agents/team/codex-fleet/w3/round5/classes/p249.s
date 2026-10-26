# n=5 model=out iset=I1 prefix14_class=249
mov S0, P1
cmp S0, P3
cmovge S0, P3
cmovge P3, P1
mov P1, S0
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovle S1, P2
cmp S1, P1
cmovl S0, S1
cmovle S1, P1
mov S0, S1
mov P2, P3
