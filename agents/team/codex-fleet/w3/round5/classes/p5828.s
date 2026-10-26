# n=5 model=out iset=I1 prefix14_class=5828
cmp P3, P2
mov S1, P2
cmovle S1, P3
cmovg P2, P3
cmp P0, P1
cmovl P3, P0
cmovl P0, P1
cmovl P1, P3
cmp S1, P1
mov S0, S1
cmovle S0, P1
cmovg S1, P1
mov P1, P0
cmp P0, P2
