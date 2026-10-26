# n=5 model=out iset=I1 prefix14_class=10601
mov S2, P1
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmovg P3, S1
cmp P2, S2
cmovle P1, P2
cmovl P2, S2
cmovge S2, P2
cmp S2, P3
cmovle S2, P3
cmovle P3, P2
cmp P0, P1
mov S2, P1
