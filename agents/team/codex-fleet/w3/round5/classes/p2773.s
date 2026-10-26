# n=5 model=out iset=I1 prefix14_class=2773
cmp P2, P3
mov S1, P2
cmovle P2, P3
cmovge S1, P3
mov S0, S1
cmp P0, P1
mov P3, P0
cmovge P0, P1
cmovl P3, P1
cmovg P1, P3
cmp P1, P2
cmovg P3, P2
cmovle P1, P2
mov P1, P3
