# n=5 model=out iset=I1 prefix14_class=5601
mov S1, P3
cmp S1, P0
cmovge P3, P0
cmovle S1, P0
mov P0, P3
cmp P2, P1
mov S0, P2
cmovl P2, P1
cmovle P1, S0
cmp P0, P1
cmovg P3, P1
cmovg P1, P0
cmp S1, P2
cmovl P3, S1
