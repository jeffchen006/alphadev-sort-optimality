# n=5 model=out iset=I1 prefix14_class=942
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovg S0, P2
mov S1, P3
cmp S1, P1
cmovge P3, P1
cmovg P1, S1
mov S1, P3
mov P2, S0
cmp P1, P2
cmovge P2, P1
cmovge P1, S0
cmp P0, S1
